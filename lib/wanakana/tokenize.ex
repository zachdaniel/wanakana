defmodule Wanakana.Tokenize do
  import Wanakana.Utils,
    only: [
      is_char_japanese_punctuation?: 1,
      is_char_kanji?: 1,
      is_char_hiragana?: 1,
      is_char_katakana?: 1
    ]

  @doc """
  Splits into sets of kanji/katakana/hiragana/romaji

  Does not split into parts of speech!

  The js version of this is more sophisticated, but I'll add that if someone needs it.

  Examples:

      iex> Wanakana.Tokenize.tokenize("")
      []
      iex> Wanakana.Tokenize.tokenize("ふふフフ")
      ["ふふ", "フフ"]
      iex> Wanakana.Tokenize.tokenize("感じ")
      ["感", "じ"]
      iex> Wanakana.Tokenize.tokenize("私は悲しい")
      ["私", "は", "悲", "しい"]
      iex> Wanakana.Tokenize.tokenize("what the...私は「悲しい」。")
      ["what the...", "私", "は", "「", "悲", "しい", "」。"]
  """
  def tokenize(input) do
    input
    |> String.to_charlist()
    |> group_tokens()
  end

  defp group_tokens(letters, acc \\ [])
  defp group_tokens([], acc), do: Enum.reverse(acc)
  defp group_tokens([letter], acc), do: group_tokens([], [to_string([letter]) | acc])

  defp group_tokens([letter | rest], acc) do
    type = get_type(letter)

    {matches, remaining} =
      Enum.split_while(rest, fn candidate ->
        get_type(candidate) == type
      end)

    token = to_string([letter | matches])

    group_tokens(remaining, [token | acc])
  end

  defp get_type(input) do
    cond do
      is_char_japanese_punctuation?(input) -> "japanese_punctuation"
      is_char_kanji?(input) -> "kanji"
      is_char_hiragana?(input) -> "hiragana"
      is_char_katakana?(input) -> "katakana"
      true -> "romaji"
    end
  end
end
