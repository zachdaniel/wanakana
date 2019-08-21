defmodule Wanakana.RomajiToKana do
  # import Wanakana.Utils,
  #   only: [
  #     is_char_katakana?: 1,
  #     is_char_slash_dot?: 1,
  #     is_char_long_dash?: 1
  #   ]

  alias Wanakana.Constants
  alias Wanakana.HiraganaToKatakana

  # @four_char_edge_cases Constants.four_char_edge_cases()
  @default_opts Constants.default_opts()
  @uppercase_start Constants.uppercase_start()
  @uppercase_end Constants.uppercase_end()
  @from_romaji Constants.from_romaji()
               |> Enum.map(fn {romaji, value} ->
                 {String.to_charlist(romaji), value}
               end)

  @obsolete_kana Constants.obsolete_kana()
                 |> Enum.map(fn {romaji, value} ->
                   {String.to_charlist(romaji), value}
                 end)

  # @vowels 'aeiouAEIOU'
  @vowels_y 'aeiouyAEIOUY'

  defguard is_alpha(x) when (x >= ?a and x <= ?z) or (x >= ?A and x <= ?Z)
  defguard upper_or_lower(x, y) when x == y or (is_alpha(x) and is_alpha(y) and abs(x - y) == 32)

  @doc """

  Examples:

      iex> Wanakana.RomajiToKana.romaji_to_kana("o")
      "お"
      iex> Wanakana.RomajiToKana.romaji_to_kana("ona")
      "おな"
      iex> Wanakana.RomajiToKana.romaji_to_kana("onaji")
      "おなじ"
      iex> Wanakana.RomajiToKana.romaji_to_kana("onaji BUTTSUUJI")
      "おなじ ブッツウジ"
      iex> Wanakana.RomajiToKana.romaji_to_kana("ONAJI buttsuuji")
      "オナジ ぶっつうじ"
      iex> Wanakana.RomajiToKana.romaji_to_kana("座禅‘zazen’スタイル")
      "座禅「ざぜん」スタイル"
      iex> Wanakana.RomajiToKana.romaji_to_kana("batsuge-mu", %{use_obsolete_kana: true})
      "ばつげーむ"
      iex> Wanakana.RomajiToKana.romaji_to_kana("!?./,~-‘’“”[](){}")
      "！？。・、〜ー「」『』［］（）｛｝"
      iex> Wanakana.RomajiToKana.romaji_to_kana("we", %{use_obsolete_kana: true})
      "ゑ"
  """
  def romaji_to_kana(input, config \\ %{}) do
    config = Map.merge(@default_opts, config)

    do_romaji_to_kana(String.to_charlist(input), config)
  end

  defp do_romaji_to_kana(input, config, acc \\ [])
  defp do_romaji_to_kana([], _config, acc), do: acc |> :lists.reverse() |> to_string()

  defp do_romaji_to_kana(input, config, acc) do
    {kana, remaining} =
      case get_chunk(input, config) do
        {:skip, kana, remaining} -> {kana, remaining}
        {kana, remaining} -> {kana, remaining}
      end

    do_romaji_to_kana(remaining, config, [kana | acc])
  end

  defp get_chunk([n, 32 | rest], %{imemode: false}) when n in 'nN' do
    {"ん", rest}
  end

  defp get_chunk([n, ?' | rest], %{imemode: true}) when n in 'nN' do
    {"ん", rest}
  end

  defp get_chunk([n, n | rest], _) when n in 'nN' do
    {"ん", rest}
  end

  defp get_chunk([first_char, second_char | _] = input, _)
       when first_char not in 'nN' and first_char not in @vowels_y and
              upper_or_lower(second_char, first_char) and
              second_char > @uppercase_start and
              second_char < @uppercase_end do
    [_ | rest] = input
    {"ッ", rest}
  end

  defp get_chunk([first_char, second_char | _] = input, _)
       when first_char not in 'nN' and first_char not in @vowels_y and
              upper_or_lower(second_char, first_char) do
    [_ | rest] = input

    {"っ", rest}
  end

  for {[romaji_first_letter, romaji_second_letter], kana} <- @obsolete_kana do
    defp get_chunk([first_letter, second_letter | rest], %{
           use_obsolete_kana: true
         })
         when upper_or_lower(first_letter, unquote(romaji_first_letter)) and
                upper_or_lower(second_letter, unquote(romaji_second_letter)) do
      {unquote(kana), rest}
    end
  end

  for {[romaji_first_letter, romaji_second_letter, romaji_third_letter, romaji_fourth_letter],
       kana} <- @from_romaji do
    defp get_chunk([first_letter, second_letter, third_letter, fourth_letter | rest], _)
         when upper_or_lower(first_letter, unquote(romaji_first_letter)) and
                upper_or_lower(second_letter, unquote(romaji_second_letter)) and
                upper_or_lower(third_letter, unquote(romaji_third_letter)) and
                upper_or_lower(fourth_letter, unquote(romaji_fourth_letter)) do
      {maybe_upcase(unquote(kana), first_letter), rest}
    end
  end

  for {[romaji_first_letter, romaji_second_letter, romaji_third_letter], kana} <- @from_romaji do
    defp get_chunk([first_letter, second_letter, third_letter | rest], _)
         when upper_or_lower(first_letter, unquote(romaji_first_letter)) and
                upper_or_lower(second_letter, unquote(romaji_second_letter)) and
                upper_or_lower(third_letter, unquote(romaji_third_letter)) do
      {maybe_upcase(unquote(kana), first_letter), rest}
    end
  end

  for {[romaji_first_letter, romaji_second_letter], kana} <- @from_romaji do
    defp get_chunk([first_letter, second_letter | rest], _)
         when upper_or_lower(first_letter, unquote(romaji_first_letter)) and
                upper_or_lower(second_letter, unquote(romaji_second_letter)) do
      {maybe_upcase(unquote(kana), first_letter), rest}
    end
  end

  for {[romaji_first_letter], kana} <- @from_romaji do
    defp get_chunk([first_letter | rest], _)
         when upper_or_lower(first_letter, unquote(romaji_first_letter)) do
      {maybe_upcase(unquote(kana), first_letter), rest}
    end
  end

  defp get_chunk([first_letter, second_letter] = ending, %{imemode: true})
       when first_letter in 'nN' and second_letter in 'yY' do
    {ending, ""}
  end

  defp get_chunk([letter | rest], _) do
    {:skip, letter, rest}
  end

  defp maybe_upcase(kana, first_letter)
       when first_letter > @uppercase_start and first_letter < @uppercase_end do
    HiraganaToKatakana.hiragana_to_katakana(kana)
  end

  defp maybe_upcase(kana, _), do: kana
end
