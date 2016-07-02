# Sortabl

A Rails Plugin to simplify sorting tables.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sortabl'
```

## Basic Usage

### Controller

#### Default

```ruby
@posts = Post.sortabl(params[:sortabl])
```

And that's it! Records will be sorted by permitted parameter `:sortabl`. If parameter `:sortabl` isn't permitted, records will be sorted by primary key. If you don't want to sort by primary key as default, you can set another one by:

```ruby
@posts = Post.sortabl(params[:sortabl], default: [author: :asc])
```

Even default multiple columns sort is possible:

```ruby
@posts = Post.sortabl(params[:sortabl], default: [author: :asc, created_at: :desc])
```

#### Limeted Attributes

Permitted values can be an attribute of model class, followed by `_asc` or `_desc`. For example: `sort: :author_asc`
If there's an attribute permitted which doesn't exist in model, it falls back to sort by `default` key. Attributes can be limited with `only` and `except`. For example:

```ruby
@posts = Post.sortabl(params[:sortabl], only: [:title, :author])
# or
@posts = Post.sortabl(params[:sortabl], except: [:text])
```


### View

#### Link Helper

There's also a link helper, which generates needed urls. It works just like you would expect from rails default link_to helper. But instead of hand over a path, just place the desired column name. The helper will do the rest for you:

```erb
<table>
  <thead>
    <th><%= sortabl_link 'Author', :author, id: 'author-column', class: 'author-column' %></th>
  </thead>
  <tbody>
    ...
  </tbody>
</table>

# Will be rendered to:
<table>
  <thead>
    <th><a id="author-column" class="sortabl author-column" href="/posts?sortabl=author_asc">Author</a></th>
    # or
    <th><a id="author-column" class="sortabl asc author-column" href="/posts?sortabl=author_desc">Author</a></th>
    # or
    <th><a id="author-column" class="sortabl desc author-column" href="/posts">Author</a></th>
  </thead>
  <tbody>
    ...
  </tbody>
</table>
```

This link helper can be placed anywhere in the view. There is no need, that it has to be placed in table head. Furthermore you can use `sortabl_link` as block too.

```erb
<%= sortabl_link :author, id: 'author-column', class: 'author-column' do %>
  <p>Author</p>
<% end %>
```

#### Parameter

By default, `sortabl_link` will generate `:sortabl` as parameter into the url. If you need to change name of the parameter, you can do so by simply:

```ruby
# In view
<%= sortabl_link 'Author', :author, sort_param: :my_custom_sort_param %>

# In controller
@posts = Post.sortabl(params[:my_custom_sort_param], only: [:title, :author])
```

Which hyperlink will be rendered, depends on permitted values.
Gem works also fine with pagination like [will_paginate](https://github.com/mislav/will_paginate).

Happy sorting ;)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

