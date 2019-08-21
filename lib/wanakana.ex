defmodule Wanakana do
  @moduledoc """
  Documentation for Wanakana.
  """

  alias Wanakana.Constants

  @default_opts Constants.default_opts()

  defdelegate is_kana(input), to: Wanakana.Utils, as: :is_kana?
  defdelegate is_hiragana(input), to: Wanakana.Utils, as: :is_hiragana?
  defdelegate is_katakana(input), to: Wanakana.Utils, as: :is_katakana?
  defdelegate to_kana(input), to: Wanakana.RomajiToKana, as: :romaji_to_kana
  defdelegate to_hiragana(input), to: Wanakana.KatakanaToHiragana, as: :katakana_to_hiragana
  defdelegate to_katakana(input), to: Wanakana.HiraganaToKatakana, as: :hiragana_to_katakana
  defdelegate to_romaji(input, opts \\ @default_opts), to: Wanakana.ToRomaji
  defdelegate strip_okurigana(input, all? \\ false), to: Wanakana.StripOkurigana
  defdelegate tokenize(input), to: Wanakana.Tokenize
end
