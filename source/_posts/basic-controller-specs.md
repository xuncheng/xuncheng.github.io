---
title: 'Basic Controller Specs'
categories: Tech
tags:
  - Rails
  - RSpec
date: 2013-07-08
---

<!-- more -->

``` ruby
require 'spec_helper'

describe TodosController do
  describe "GET index" do
    it "populates an array of todos" do
      cook = Todo.create(name: "cook")
      get :index
      expect(assigns(:todos)).to match_array([cook])
    end

    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    it "assigns the requested todo to @todo" do
      cook = Todo.create(name: "cook")
      get :show, id: cook
      expect(assigns(:todo)).to eq(cook)
    end

    it "renders the :show template" do
      cook = Todo.create(name: "cook")
      get :show, id: cook
      expect(response).to render_template :show
    end
  end

  describe "GET new" do
    it "assigns a new Todo to @todo" do
      get :new
      expect(assigns(:todo)).to be_a_new(Todo)
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "saves the new todo in the database" do
        expect{
          post :create, todo: {name: "cook", description: "I like cooking."}
        }.to change(Todo, :count).by(1)
      end

      it "redirects to the root path" do
        post :create, todo: {name: "cook", description: "I like cooking."}
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid attributes" do
      it "does not save the new todo in the database" do
        expect{
          post :create, todo: {description: "I like cooking."}
        }.to_not change(Todo, :count)
      end

      it "re-renders the :new template" do
        post :create, todo: {description: "I like cooking."}
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested todo to @todo" do
      cook = Todo.create(name: "cook")
      get :edit, id: cook
      expect(assigns(:todo)).to eq cook
    end

    it "renders the :edit template" to
      cook = Todo.create(name: "cook")
      get :edit, id: cook
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do
    it "locates the requested @todo" do
      cook = Todo.create(name: "cook")
      put :update, id: cook, todo: {name: "cooking"}
      expect(assigns(:todo)).to eq(cook)
    end

    context "with valid attributes" do
      it "updates the todo in the database" do
        cook = Todo.create(name: "cook")
        put :update, id: cook, todo: {name: "cooking"}
        cook.reload
        expect(cook.name).to eq("cooking")
      end

      it "redirects to the todo" do
        cook = Todo.create(name: "cook")
        put :update, id: cook, todo: {name: "cooking"}
        expect(response).to redirect_to cook
      end
    end

    context "with invalid attributes" do
      it "does not update the todo in the database" do
        cook = Todo.create(name: "cook", description: "I like cooking.")
        put :update, id: cook, todo: {name: nil, description: "none update"}
        cook.reload
        expect(cook.description).to_not eq("none update")
      end

      it "re-renders the :edit template" do
        cook = Todo.create(name: "cook", description: "I like cooking.")
        put :update, id: cook, todo: {name: nil, description: "none update"}
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    it "deletes the todo from the database" do
      cook = Todo.create(name: "cook")
      expect{
        delete :destroy, id: cook
      }.to change(Todo, :count).by(-1)
    end

    it "redirects to the root path" do
      cook = Todo.create(name: "cook")
      delete :destroy, id: cook
      expect(response).to redirect_to root_path
    end
  end
end
```
