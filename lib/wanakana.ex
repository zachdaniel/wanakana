defmodule Wanakana do
  @moduledoc """
  Documentation for Wanakana.
  """

  defdelegate is_kana?(input), to: Wanakana.Utils
  defdelegate is_hiragana?(input), to: Wanakana.Utils
  defdelegate is_katakana?(input), to: Wanakana.Utils
  defdelegate to_kana(input, opts \\ %{}), to: Wanakana.RomajiToKana, as: :romaji_to_kana
  defdelegate to_hiragana(input, opts \\ %{}), to: Wanakana.ToHiragana
  defdelegate to_katakana(input), to: Wanakana.ToKatakana
  defdelegate to_romaji(input, opts \\ %{}), to: Wanakana.ToRomaji
  defdelegate strip_okurigana(input, all? \\ false), to: Wanakana.StripOkurigana
  defdelegate tokenize(input), to: Wanakana.Tokenize
end
