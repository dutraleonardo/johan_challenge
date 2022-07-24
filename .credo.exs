%{
  configs: [
    %{
      name: "default",
      checks: [
        {Credo.Check.Refactor.Nesting, max_nesting: 3}
      ],
      files: %{
        included: ["mix.exs", "lib/"],
        excluded: ["test/", "lib/johan_challenge_web/telemetry.ex", "lib/johan_challenge/mailer.ex"]
      }
    }
  ]
}
