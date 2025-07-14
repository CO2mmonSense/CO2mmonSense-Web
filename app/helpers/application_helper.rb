module ApplicationHelper
    def user_avatar(user, width = 200, height = 200)
        if user.avatar.attached?
            user.avatar.variant(resize_to_fill: [width, height], format: "jpg").processed
        else
            image_url("default_avatar.jpg")
        end
    end
end
