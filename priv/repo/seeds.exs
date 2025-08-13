alias Lms.{Repo}
alias Lms.Accounts.User
alias Lms.Catalog.{Course, Lesson}

# Admin user
{:ok, _} =
  %User{}
  |> User.registration_changeset(%{
    email: "admin@example.com",
    password: "admin123",
    role: "admin"
  })
  |> Repo.insert()

course =
  Repo.insert!(%Course{
    title: "Алгебра 10",
    slug: "algebra-10",
    description: "Негізгі тақырыптар",
    published: true,
    price_kzt: 0,
    position: 1
  })

Repo.insert!(%Lesson{
  course_id: course.id,
  title: "Кіріспе",
  lesson_type: "text",
  content_md: "# Сәлем!\nБұл алғашқы сабақ.",
  position: 1,
  free_preview: true
})
