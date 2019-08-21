defmodule Wanakana.HiraganaToKatakana do
  import Wanakana.Utils,
    only: [
      #     is_char_katakana?: 1,
      is_char_slash_dot?: 1,
      is_char_long_dash?: 1,
      is_char_hiragana?: 1
    ]

  alias Wanakana.Constants

  @hiragana_start Constants.hiragana_start()
  @katakana_start Constants.katakana_start()

  @doc """
  Converts hiragana to katakana

  Examples:

      iex> Wanakana.HiraganaToKatakana.hiragana_to_katakana("ひらがな")
      "ヒラガナ"
      iex> Wanakana.HiraganaToKatakana.hiragana_to_katakana("ひらがな is a type of kana")
      "ヒラガナ is a type of kana"
  """
  def hiragana_to_katakana(input) do
    input
    |> String.to_charlist()
    |> Enum.map(fn char ->
      cond do
        is_char_long_dash?(char) || is_char_slash_dot?(char) ->
          char

        is_char_hiragana?(char) ->
          char + (@katakana_start - @hiragana_start)

        true ->
          char
      end
    end)
    |> to_string()
  end
end
