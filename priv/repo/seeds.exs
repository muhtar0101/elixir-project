# priv/repo/seeds.exs
alias Lms.Repo
alias Lms.Accounts.User
alias Lms.Catalog.{Course, Lesson}

admin_email = "admin@example.com"
admin_pass  = "admin123"

# 1) Админді тексеріп/қосу
admin =
  case Repo.get_by(User, email: admin_email) do
    nil ->
      pwd_hash = Bcrypt.hash_pwd_salt(admin_pass)
      Repo.insert!(%User{email: admin_email, role: "admin", password_hash: pwd_hash})
    user -> user
  end

IO.puts("ADMIN READY: email=#{admin_email}  password=#{admin_pass}")

# 2) Курс
course =
  Repo.get_by(Course, slug: "algebra-10") ||
    Repo.insert!(%Course{
      title: "Алгебра 10",
      slug: "algebra-10",
      description: "Негізгі тақырыптар",
      published: true,
      price_kzt: 0,
      position: 1
    })

# 3) Бір preview-сабақ
Repo.get_by(Lesson, course_id: course.id, position: 1) ||
  Repo.insert!(%Lesson{
    course_id: course.id,
    title: "Кіріспе",
    lesson_type: :text,        # Ecto.Enum -> atom БОЛУЫ КЕРЕК!
    content_md: "# Сәлем!\nБұл алғашқы сабақ.",
    position: 1,
    free_preview: true
  })
