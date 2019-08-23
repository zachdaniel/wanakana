defmodule Wanakana.ToHiragana do
  import Wanakana.Utils,
    only: [
      is_char_katakana?: 1,
      is_char_slash_dot?: 1,
      is_char_long_dash?: 1,
      is_romaji?: 1,
      is_mixed?: 1
    ]

  alias Wanakana.{Constants, RomajiToKana}

  @to_romaji Constants.to_romaji()
  @long_vowels Constants.long_vowels()
  @hiragana_start Constants.hiragana_start()
  @katakana_start Constants.katakana_start()
  @default_opts Constants.default_opts()

  @doc """
  Converts katakana to hiragana

      iex> Wanakana.ToHiragana.to_hiragana("カタカナ")
      "かたかな"
      iex> Wanakana.ToHiragana.to_hiragana("オー")
      "おう"
  """
  def to_hiragana(katakana, opts \\ %{}) do
    opts = Map.merge(@default_opts, opts)

    cond do
      Map.get(opts, :pass_romaji) ->
        do_to_hiragana(katakana)

      is_romaji?(katakana) ->
        RomajiToKana.romaji_to_kana(katakana, opts)

      is_mixed?(katakana) ->
        katakana
        |> do_to_hiragana()
        |> RomajiToKana.romaji_to_kana(opts)

      true ->
        do_to_hiragana(katakana)
    end
  end

  defp do_to_hiragana(katakana) do
    katakana
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce({[], nil}, fn {char, index}, {hira, previous_kana} ->
      slash_dot? = is_char_slash_dot?(char)
      long_dash? = is_char_long_dash?(char)

      cond do
        slash_dot? || (long_dash? && index == 0) ->
          {[char | hira], previous_kana}

        not is_nil(previous_kana) && index > 0 && long_dash? ->
          romaji = Map.get(@to_romaji, to_string([previous_kana]))
          last = romaji |> String.to_charlist() |> :lists.last()

          case Map.get(@long_vowels, [last]) do
            nil ->
              {[romaji | hira], previous_kana}

            hit ->
              {[to_string([hira, hit])], previous_kana}
          end

        !long_dash? && is_char_katakana?(char) ->
          new_char = char + (@hiragana_start - @katakana_start)

          {[to_string([new_char]) | hira], new_char}

        true ->
          {[<<char>> | hira], nil}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
    |> to_string()
  end
end
