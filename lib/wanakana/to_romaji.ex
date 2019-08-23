defmodule Wanakana.ToRomaji do
  import Wanakana.Utils,
    only: [
      is_katakana?: 1
    ]

  alias Wanakana.Constants
  alias Wanakana.ToHiragana

  @default_opts Constants.default_opts()
  @to_romaji Constants.to_romaji()

  @doc """
  Converts hiragana/katakana to romaji

      iex> Wanakana.ToRomaji.to_romaji("ひらがな　カタカナ")
      "hiragana katakana"
      iex> Wanakana.ToRomaji.to_romaji("ひらがな　カタカナ", %{upcase_katakana: true})
      "hiragana KATAKANA"
  """
  def to_romaji(string, opts \\ %{}) do
    opts = Map.merge(@default_opts, opts)
    do_to_romaji(string, opts)
  end

  defp do_to_romaji(string, opts, double_consonant? \\ false, acc \\ [])

  defp do_to_romaji("", _, _, acc) do
    acc
    |> :lists.reverse()
    |> to_string()
  end

  defp do_to_romaji(string, opts, double_consonant?, acc) do
    {letter, remaining} = String.split_at(string, 1)

    {uppercase?, letter} =
      if is_katakana?(letter) do
        {true, ToHiragana.to_hiragana(letter)}
      else
        {false, letter}
      end

    case remaining do
      "っ" <> rest ->
        romaji =
          @to_romaji
          |> Map.get(letter, letter)
          |> maybe_uppercase(uppercase?, opts)
          |> maybe_double(double_consonant?)

        do_to_romaji(rest, opts, true, [romaji | acc])

      _ ->
        romaji =
          @to_romaji
          |> Map.get(letter, letter)
          |> maybe_uppercase(uppercase?, opts)
          |> maybe_double(double_consonant?)

        do_to_romaji(remaining, opts, false, [romaji | acc])
    end
  end

  defp maybe_uppercase(input, true, %{upcase_katakana: true}), do: String.upcase(input)
  defp maybe_uppercase(input, _, _), do: input

  defp maybe_double(<<letter>> <> rest, true),
    do: <<letter, letter>> <> rest

  defp maybe_double(input, _), do: input
end
