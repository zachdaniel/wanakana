use Mix.Config

if Mix.env() == :dev do
  config :git_ops,
    mix_project: Wanakana.MixProject,
    changelog_file: "CHANGELOG.md",
    repository_url: "https://github.com/zachdaniel/wanakana",
    manage_mix_version?: true,
    manage_readme_version: "README.md"
end
