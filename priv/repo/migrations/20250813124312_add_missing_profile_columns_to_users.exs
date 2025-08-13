defmodule Lms.Repo.Migrations.AddMissingProfileColumnsToUsers do
  use Ecto.Migration

  def up do
    # Бар болса — ештеңе істемейді, жоқ болса — қосады
    execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS login text")
    execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS full_name text")
    execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS phone text")
    execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS school text")
    execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS role varchar(20)")
    execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS hashed_password text")

    execute("CREATE UNIQUE INDEX IF NOT EXISTS users_login_index ON users (login)")
    execute("CREATE UNIQUE INDEX IF NOT EXISTS users_email_index ON users (email)")

    # role бос жазбалар болса, default-ты орнатып қоямыз
    execute("UPDATE users SET role = 'student' WHERE role IS NULL")
  end

  def down do
    # әдетте down керек емес; қауіпсіз болсын десеңіз, тек индексті түсіріп қойдық
    execute("DROP INDEX IF EXISTS users_login_index")
  end
end
