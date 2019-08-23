defmodule Wanakana.ToKatakana do
  import Wanakana.Utils,
    only: [
      is_char_slash_dot?: 1,
      is_char_long_dash?: 1,
      is_char_hiragana?: 1,
      is_romaji?: 1,
      is_mixed?: 1
    ]

  alias Wanakana.Constants
  alias Wanakana.RomajiToKana

  @hiragana_start Constants.hiragana_start()
  @katakana_start Constants.katakana_start()
  @default_opts Constants.default_opts()

  @doc """
  Converts hiragana to katakana

  Examples:

      iex> Wanakana.ToKatakana.to_katakana("ひらがな")
      "ヒラガナ"
      iex> Wanakana.ToKatakana.to_katakana("ひらがな is a type of kana", %{pass_romaji: true})
      "ヒラガナ is a type of kana"
  """
  def to_katakana(input, opts \\ %{}) do
    opts = Map.merge(@default_opts, opts)

    cond do
      Map.get(opts, :pass_romaji) ->
        do_to_katakana(input)

      is_romaji?(input) || is_mixed?(input) ->
        input
        |> RomajiToKana.romaji_to_kana(opts)
        |> do_to_katakana()

      true ->
        do_to_katakana(input)
    end
  end

  defp do_to_katakana(input) do
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
