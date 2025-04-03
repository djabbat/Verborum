defmodule BouquetVerborum.RecordMigrator do
  alias BouquetVerborum.MariaRepo
  alias BouquetVerborum.Repo
  alias BouquetVerborum.MariaLexicon, as: MariaRecord
  alias BouquetVerborum.Lexicon, as: MainRecord

  def migrate_records do
    MariaRepo.all(MariaRecord)
    |> Enum.each(&insert_into_main_db/1)
  end

  defp insert_into_main_db(%MariaRecord{} = record) do
    %MainRecord{}
    |> MainRecord.changeset(%{
      word: record.word,
      meaning: record.meaning,
      origin: record.origin,
      book: record.book,
      chapter: record.chapter,
      paragraph: record.paragraph,
      latitude: record.latitude,
      longitude: record.longitude,
      language: record.language
    })
    |> Repo.insert()
  end
end
