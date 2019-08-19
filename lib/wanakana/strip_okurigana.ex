defmodule Wanakana.StripOkurigana do
  import Wanakana.Utils,
    only: [
      is_char_kana?: 1,
      is_char_kanji?: 1,
      is_japanese?: 1,
      is_kana?: 1,
      is_char_punctuation?: 1
    ]

  @doc """
  Strips trailing okurigana, or all okurigana if `all?` is `true`

  Examples:

      iex> Wanakana.StripOkurigana.strip_okurigana("踏み込む")
      "踏み込"
      iex> Wanakana.StripOkurigana.strip_okurigana("粘り。", true)
      "粘。"
      iex> Wanakana.StripOkurigana.strip_okurigana("お祝い")
      "お祝"
      iex> Wanakana.StripOkurigana.strip_okurigana("踏み込む", true)
      "踏込"
      iex> Wanakana.StripOkurigana.strip_okurigana("お祝い", true)
      "祝"
  """
  def strip_okurigana(input, all? \\ false) do
    cond do
      !is_japanese?(input) and !is_kana?(input) ->
        input

      all? ->
        input
        |> String.to_charlist()
        |> Enum.reject(&is_char_kana?/1)
        |> to_string()

      true ->
        input
        |> String.to_charlist()
        |> Enum.reverse()
        |> Enum.drop_while(fn char ->
          is_char_punctuation?(char) || !is_char_kanji?(char)
        end)
        |> Enum.reverse()
        |> to_string()
    end
  end
end
