defmodule LmsWeb.Router do
  use LmsWeb, :router
  import LmsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LmsWeb do
    pipe_through :browser

    # Аутентификация
    get   "/login",  AuthController, :login_form
    post  "/login",  AuthController, :login
    get   "/logout", AuthController, :logout
    delete "/logout", AuthController, :logout

    # Тіркелу
    get  "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    # Сатып алу
    post "/purchase/:slug", PurchaseController, :create

    # Қонақ беттері
    live "/", HomeLive, :index
    live "/courses/:slug", CourseShowLive, :show
    live "/courses/:slug/lessons/:id", LessonShowLive, :show
  end

  scope "/admin", LmsWeb.Admin do
    pipe_through :browser
    plug :require_admin

    live "/users", UsersLive, :index
    live "/users/:id/edit", UserEditLive, :edit
    live "/courses/:id/edit", CourseEditorLive, :edit
    # Қажетіне қарай admin роуттарын осы жерге қосамыз
  end
end
