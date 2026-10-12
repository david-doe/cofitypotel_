let
    Source = Csv.Document(File.Contents(DossierSorties & "migrations.csv"), [Delimiter = ";", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    Entetes = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Textes = {"depart", "arrivee"},
    Nombres = List.Difference(Table.ColumnNames(Entetes), Textes),
    Types = Table.TransformColumnTypes(Entetes, List.Transform(Nombres, each {_, type number}) & List.Transform(Textes, each {_, type text}), "fr-FR")
in
    Types
