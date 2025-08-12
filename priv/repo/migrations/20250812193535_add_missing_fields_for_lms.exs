defmodule Lms.Repo.Migrations.AddMissingFieldsForLms do
  use Ecto.Migration

  def change do
    # COURSES: жетіспейтін бағандар
    execute("""
    ALTER TABLE courses
      ADD COLUMN IF NOT EXISTS price_kzt integer NOT NULL DEFAULT 0
    """)

    execute("""
    ALTER TABLE courses
      ADD COLUMN IF NOT EXISTS position integer NOT NULL DEFAULT 0
    """)

    execute("""
    ALTER TABLE courses
      ADD COLUMN IF NOT EXISTS published boolean NOT NULL DEFAULT false
    """)

    execute("""
    ALTER TABLE courses
      ADD COLUMN IF NOT EXISTS slug varchar(255)
    """)

    execute("""
    ALTER TABLE courses
      ADD COLUMN IF NOT EXISTS description text
    """)

    execute("""
    CREATE UNIQUE INDEX IF NOT EXISTS courses_slug_index ON courses (slug)
    """)

    # LESSONS: жетіспейтін бағандар
    execute("""
    ALTER TABLE lessons
      ADD COLUMN IF NOT EXISTS lesson_type varchar(32)
    """)

    execute("""
    ALTER TABLE lessons
      ADD COLUMN IF NOT EXISTS content_md text
    """)

    execute("""
    ALTER TABLE lessons
      ADD COLUMN IF NOT EXISTS position integer NOT NULL DEFAULT 0
    """)

    execute("""
    ALTER TABLE lessons
      ADD COLUMN IF NOT EXISTS free_preview boolean NOT NULL DEFAULT false
    """)
  end
end
