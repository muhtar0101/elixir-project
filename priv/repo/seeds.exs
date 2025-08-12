# priv/repo/seeds.exs

alias Lms.Repo
alias Lms.Catalog.{Course, Lesson}
alias Lms.Accounts
Accounts.register_user(%{email: "admin@lms.local", password: "admin123", role: "admin"})
# Егер Accounts.User схемасы бар болса ғана админ жасаймыз:
admin_email = "admin@lms.local"
if Code.ensure_loaded?(Lms.Accounts.User) do
  alias Lms.Accounts.User
  Repo.get_by(User, email: admin_email) ||
    (%User{} |> User.registration_changeset(%{email: admin_email, password: "admin123", role: "admin"}) |> Repo.insert!())
end

# Негізгі курс
course =
  Repo.get_by(Course, slug: "algebra-10") ||
  Repo.insert!(%Course{
    title: "Алгебра 10",
    slug: "algebra-10",
    description: "Алгебра курсы",
    price_kzt: 5000,        # price_cents емес, дәл осы өріс бар
    published: true,
    position: 1
  })

# Алғашқы сабақтар (preview + video сияқты)
Repo.get_by(Lesson, %{course_id: course.id, position: 1}) ||
  Repo.insert!(%Lesson{
    course_id: course.id,
    title: "Кіріспе",
    position: 1,
    lesson_type: "text",
    free_preview: true,
    content_md: "# Сәлем\nБұл — preview сабақ."
  })

Repo.get_by(Lesson, %{course_id: course.id, position: 2}) ||
  Repo.insert!(%Lesson{
    course_id: course.id,
    title: "Видео сабақ",
    position: 2,
    lesson_type: "video",
    # Видеоға әзірге сілтемені content_md ішінде сақтаймыз (MVP)
    content_md: "https://example.com/video.mp4"
  })

# Тағы бір курс (алдымен жоқ болса ғана)
Repo.get_by(Course, slug: "algebra-9") ||
  Repo.insert!(%Course{
    title: "Алгебра 9",
    slug: "algebra-9",
    description: "Алгебра бойынша базалық курс",
    published: true,
    price_kzt: 10000,
    position: 2
  })
# Admin user (қажет болса phx.gen.auth-тың Accounts.create_user/1 атауы өзгеше болуы мүмкін)
{:ok, _admin} =
  Accounts.register_user(%{
    email: "admin@qazmath.net",
    password: "Admin123!@#",
    password_confirmation: "Admin123!@#"
  })

# Бір курс (міндетті published: true)
Repo.insert!(%Course{
  title: "Алгебра 10",
  slug: "algebra-10",
  description: "Алгебра курсы",
  published: true,
  price_kzt: 0,
  position: 1
})
