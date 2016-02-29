class PermissionService
  attr_reader :user, :controller, :action

  def initialize(user)
    @user = user
  end

  def allow?(controller, action)
    @controller = controller
    @action = action

    case
    when user then user_permissions
    else
      logged_out_permissions
    end
  end

private

  def user_permissions
    return [true, :ok] if controller == "dashboards"
    return [true, :ok] if controller == "sessions"
    return [true, :ok] if controller == "journal_entries"
    [false, "/dashboard"]
  end

  def logged_out_permissions
    return [true, :ok] if controller == "home"
    return [true, :ok] if controller == "sessions"
    [false, "/"]
  end
end
