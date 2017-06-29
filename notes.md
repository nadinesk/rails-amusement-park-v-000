# Model Tests
## User
users with:
* name
* password_digest
* nausea
* happiness
* tickets
* height
* admin - default false (0)

Valid
- name, password, nausea, height, tickets
- admin boolean

validates_presence_of :name
validates_presence_of :nausea
validates_presence_of :height
validates_presence_of :tickets
validates :password, presence: true, confirmation: true, length: { minimum: 8 }
# validates_presence_of :admin ?



has_many :rides
has_many :attractions, through: :rides

has_secure_password

def mood
  if self.happiness && self.nausea
    if self.nausea > self.happiness
      mood = "sad"
    else
      mood = "happy"
    end
  end
end

## Attraction

attractions with
* name
* tickets
* nausea_rating
* happiness_rating
* min-height


Valid
- with name, min_height, nausea_rating, happiness_rating, tickets

has_many :rides
has_many :users, through: :rides


validates_presence_of :name
validates_presence_of :min_height
validates_presence_of :nausea_rating
validates_presence_of :happiness_rating
validates_presence_of :tickets

#Ride

rides with
* user_id
* attraction_id

Valid
- with user_id and attraction_id

validates_presence_of :user_id
validates_presence_of :attraction_id
belongs_to :attraction
belongs_to :user


def take_ride
  if (self.user.height < self.attraction.min_height) && (self.user.tickets < self.attraction.tickets)
    "Sorry. You do not have enough tickets to ride the #{self.attraction.name}. You are not tall enough to ride the #{self.attraction.name}."
  elsif (self.user.tickets < self.attraction.tickets) && !(self.user.height < self.attraction.min_height)
      "Sorry. You do not have enough tickets to ride the #{self.attraction.name}."
  elsif (self.user.height < self.attraction.min-height) && !(self.user.tickets < self.attraction.tickets)
        "Sorry. You are not tall enough to ride the #{self.attraction.name}"
  else
    self.user.tickets = self.attraction.tickets - self.user.tickets
    self.user.happiness += self.attraction.happiness_rating
    self.user.nausea += self.attraction.nausea_rating
  end
end



end

# Feature Tests

config

get 'users/new'

get '/login' => 'sessions#new'
post '/login' => 'sessions#create'
post '/logout' => 'sessions#destroy'

resources :users



## signup -> /users/new.html.erb

<%= form_for @user, controller: 'users', action: 'create' do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :password %>
  <%= f.password_field :password %>

  <%= f.label :password_confirmation %>
  <%= f.password_field :password_confirmation %>

  <%= f.label :height %>
  <%= f.text_field :height %>

  <%= f.label :happiness %>
  <%= f.text_field :happiness %>

  <%= f.label :nausea %>
  <%= f.text_field :nausea %>

  <%= f.label :tickets %>
  <%= f.text_field :tickets %>

  <%= f.label :admin %>
  <%= f.check_box :admin %>

  <%= f.submit "Create User" %>
<% end %>

## Users_controller.rb

def new

end

def create
  @user = User.create(user_params)
  return redirect_to controller: 'users', action: 'new' unless @user.save
  session[:user_id] = @user.id
  redirect_to user_path(id: @user.id)
end

def show
  unless current_user.admin?
     unless @user == current_user
       redirect_to :back, :alert => "Access denied."
     end
   end
end

private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end

#################

## Sessions_Controller.rb

def new
end

def create

  user = User.find_by(name: params[:user][:name])
  user = user.try(:authenticate, params[:user][:password])
  return redirect_to(controller: 'sessions', action: 'new') unless user
  session[:user_id] = user.id
  @user = user
  redirect_to user_path(id: @user.id)
end

def destroy
  session.delete :user_id
  redirect_to '/'
end



end


## app/views/sessions/new.html.erb

<%= form_for @user, url: login_path, method: :post do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name %>

  <%= f.label :password %>
  <%= f.password_field :password %>

  <%= f.submit "log in" %>
  Or <%= link_to(controller: 'users', action: 'new') { 'sign up' } %>
<% end %>



## app/views/layout/_nav_links_for_auth.html.erb

<% if current_user %>
  <li><%= link_to 'Attractions', '/attractions' %></li>
  <li><%= link_to 'Log out', logout_path, :method=>'delete' %></li>
<% else %>
  <li><%= link_to 'Sign in', login_path, :method=>'post' %></li>
  <li><%= link_to 'Sign up', controller: 'users', action: 'new' %></li>
<% end %>
<% if user_signed_in? %>
  <% if current_user.try(:admin?) %>
    <li><%= link_to 'Users', users_path %></li>
  <% end %>
<% end %>

## app/views/layout/_navigation.html.erb

<ul class="nav">
  <li><%= link_to 'Home', root_path %></li>
  <%= render 'layouts/navigation_links' %>
        <%= render 'layouts/nav_links_for_auth' %>
</ul>

## messages

<% flash.each do |name, msg| %>
  <% if msg.is_a?(String) %>
    <%= content_tag :div, msg, :class => "flash_#{name}" %>
  <% end %>
<% end %>
