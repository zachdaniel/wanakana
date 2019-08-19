defmodule Wanakana.KatakanaToHiragana do
  import Wanakana.Utils,
    only: [
      is_char_katakana?: 1,
      is_char_slash_dot?: 1,
      is_char_long_dash?: 1
    ]

  alias Wanakana.Constants

  @to_romaji Constants.to_romaji()
  @long_vowels Constants.long_vowels()
  @hiragana_start Constants.hiragana_start()
  @katakana_start Constants.katakana_start()

  @doc """
  Converts katakana to hiragana

      iex> Wanakana.KatakanaToHiragana.katakana_to_hiragana("カタカナ")
      "かたかな"
      iex> Wanakana.KatakanaToHiragana.katakana_to_hiragana("オー")
      "おう"
  """
  def katakana_to_hiragana(katakana) do
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
