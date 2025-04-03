defmodule BouquetVerborum.Repo.Migrations.AddSearchIndexes do
  use Ecto.Migration

  def up do
    # Активируем необходимые расширения
    execute "CREATE EXTENSION IF NOT EXISTS unaccent"
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm"

    # Создаем immutable-версию функции unaccent
    execute """
    CREATE OR REPLACE FUNCTION immutable_unaccent(text)
    RETURNS text AS $$
    BEGIN
      RETURN unaccent('unaccent', $1);
    END;
    $$ LANGUAGE plpgsql IMMUTABLE;
    """

    # Для поля word (обычно короче)
    create index(:lexicon, ["lower(word) varchar_pattern_ops"], name: "lexicon_word_search_idx")

    # Для поля meaning используем частичный индекс для более коротких значений
    execute """
    CREATE INDEX lexicon_meaning_search_idx ON lexicon
    (lower(meaning) varchar_pattern_ops)
    WHERE length(meaning) < 1000
    """

    # Для bible.text также используем частичный индекс
    execute """
    CREATE INDEX bible_text_search_idx ON bible
    (lower(text) varchar_pattern_ops)
    WHERE length(text) < 1000
    """

    # GIN индексы для триграммного поиска (работают с длинным текстом)
    execute """
    CREATE INDEX IF NOT EXISTS lexicon_word_trgm_idx
    ON lexicon USING gin (word gin_trgm_ops)
    """

    execute """
    CREATE INDEX IF NOT EXISTS lexicon_meaning_trgm_idx
    ON lexicon USING gin (meaning gin_trgm_ops)
    """

    execute """
    CREATE INDEX IF NOT EXISTS bible_text_trgm_idx
    ON bible USING gin (text gin_trgm_ops)
    """
  end

  def down do
    drop index(:lexicon, [:word], name: "lexicon_word_search_idx")
    execute "DROP INDEX IF EXISTS lexicon_meaning_search_idx"
    execute "DROP INDEX IF EXISTS bible_text_search_idx"

    execute "DROP INDEX IF EXISTS lexicon_word_trgm_idx"
    execute "DROP INDEX IF EXISTS lexicon_meaning_trgm_idx"
    execute "DROP INDEX IF EXISTS bible_text_trgm_idx"

    execute "DROP FUNCTION IF EXISTS immutable_unaccent(text)"
    execute "DROP EXTENSION IF EXISTS unaccent"
    execute "DROP EXTENSION IF EXISTS pg_trgm"
  end
end
