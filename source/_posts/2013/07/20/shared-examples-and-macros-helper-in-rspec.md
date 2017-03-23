---
title: 'Shared examples and Macros helper in RSpec'
categories: Tech
tags:
  - RSpec
  - Shared examples
  - Macros
---

## Shared examples
RSpec gives us a nice way to clean up this replication with *shared examples*. Setting up a shared example is pretty simple-first, create a block for the examples as follow.

adding a new file **app/spec/support/shared_examples.rb**

``` ruby
shared_examples "require login" do
  it "redirects to the user sign in path" do
    action # defined in the spec  	
    expect(response).to redirect_to signin_path
  end
end
```

and use it (in **app/spec/controllers/queue_videos_controller_spec.rb**)

``` ruby
describe "GET index"
  context "with unauthenticated users" do
    it_behaves_like "require login" do
      let(:action) { get :index }
    end
  end
end
```

<!-- more -->

## Macros helper
Macros are an easy way to create methods which maybe used across your entire test suite. Macons conventionally go into the *spec/support* directory as a module to be included in Rspec's configuration.

adding a new file **app/spec/support/macros.rb**

``` ruby
def set_user_session(user)
  cookies[:remember_token] = user.remember_token
end
```

and use it (in **app/spec/controllers/queue_videos_controller_spec.rb**)

``` ruby
describe "GET index" do
  it "renders the :index template for authenticated users" do
    current_user = Fabricate(:user)
    set_user_session(current_user)
    queue_video = Fabricate(:queue_video, user: current_user)
    get :index
    expect(response).to render_template :index
  end
end
```
