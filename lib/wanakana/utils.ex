defmodule Wanakana.Utils do
  alias Wanakana.Constants

  @hiragana_start Constants.hiragana_start()
  @hiragana_end Constants.hiragana_end()
  @katakana_start Constants.katakana_start()
  @katakana_end Constants.katakana_end()
  @kanji_start Constants.kanji_start()
  @kanji_end Constants.kanji_end()
  @ja_punctuation_ranges Constants.ja_punctuation_ranges()
  @en_punctuation_ranges Constants.en_punctuation_ranges()
  @japanese_ranges Constants.japanese_ranges()
  @kana_slash_dot Constants.kana_slash_dot()

  @prolonged_sound_mark Constants.prolonged_sound_mark()

  def is_japanese?(""), do: false

  def is_japanese?(string) do
    string
    |> String.to_charlist()
    |> Enum.all?(&is_char_japanese?/1)
  end

  def is_kana?(""), do: false

  def is_kana?(string) do
    string
    |> String.to_charlist()
    |> Enum.all?(&is_char_kana?/1)
  end

  def is_katakana?(""), do: false

  def is_katakana?(string) do
    string
    |> String.to_charlist()
    |> Enum.all?(&is_char_katakana?/1)
  end

  def is_char_slash_dot?(@kana_slash_dot), do: true
  def is_char_slash_dot?(_), do: false

  for [start, end_range] <- @japanese_ranges do
    def is_char_japanese?(char) when char >= unquote(start) and char <= unquote(end_range),
      do: true
  end

  def is_char_japanese?(char), do: false

  # is_char_japanese_punctiation?(input) -> "japanese_punctuation"
  def is_char_katakana?(char) do
    is_char_in_range?(char, @katakana_start, @katakana_end)
  end

  def is_char_hiragana?(char) do
    is_char_long_dash?(char) || is_char_in_range?(char, @hiragana_start, @hiragana_end)
  end

  def is_char_kanji?(char) do
    is_char_in_range?(char, @kanji_start, @kanji_end)
  end

  for [start, end_range] <- @ja_punctuation_ranges do
    def is_char_japanese_punctuation?(char)
        when char >= unquote(start) and char <= unquote(end_range),
        do: true
  end

  def is_char_japanese_punctuation?(_), do: false

  for [start, end_range] <- @en_punctuation_ranges do
    def is_char_english_punctuation?(char)
        when char >= unquote(start) and char <= unquote(end_range),
        do: true
  end

  def is_char_english_punctuation?(_), do: false

  def is_char_punctuation?(char),
    do: is_char_english_punctuation?(char) || is_char_japanese_punctuation?(char)

  def is_char_kana?(char), do: is_char_hiragana?(char) || is_char_katakana?(char)

  def is_char_long_dash?(@prolonged_sound_mark), do: true
  def is_char_long_dash?(_), do: false

  # def is_kanji?(""), do: false
  # def is_kanji?(kanji) do
  #   kanji
  #   |> String.
  # end
  defp is_char_in_range?(char, start_range, _) when char < start_range, do: false
  defp is_char_in_range?(char, _, end_range) when char > end_range, do: false
  defp is_char_in_range?(_, _, _), do: true
end
