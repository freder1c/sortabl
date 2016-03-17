# Sortabl

A Rails Plugin to simplify sorting tables.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sortabl'
```

## Basic Usage

### Controller

```ruby
@posts = Post.sortabl(sort_by: params[:sortabl])
```

And that's it! Records will be sorted by permitted parameter `:sortabl`. If parameter `:sortabl` isn't permitted, records will be sorted by primary key. If you don't want to sort by primary key by default, you can set another one by:

```ruby
@posts = Post.sortabl(sort_by: params[:sortabl], default: :author)
```

Permitted values can be an attribute of model class, followed by `_asc` or `_desc`. For example: `sort: :author_asc`
If there's an attribute permitted which doesn't exist in model, it falls back to sort by `default` key. Attributes can be limited with `only` and `except`. For example:

```ruby
@posts = Post.sortabl(sort_by: params[:sortabl], only: [:title, :author])
# or
@posts = Post.sortabl(sort_by: params[:sortabl], except: [:text])
```


### View

There's also a view helper for rendering table heads:

```erb
<table>
	<thead>
		<%= sortabl_th 'Author', :author, id: 'author-column', class: 'author-column' %>
	</thead>
	<tbody>
		...
	</tbody>
</table>

# Will be rendered to:
<table>
	<thead>
		<th id="author-column" class="sortabl author-column"><a href="/posts?sortabl=author_asc">Author<i class="fa fa-sort"></i></a></th>
		# or
		<th id="author-column" class="sortabl asc author-column"><a href="/posts?sortabl=author_desc">Author<i class="fa fa-sort-asc"></i></a></th>
		# or
		<th id="author-column" class="sortabl desc author-column"><a href="/posts">Author<i class="fa fa-sort-desc"></i></a></th>
	</thead>
	<tbody>
		...
	</tbody>
</table>
```

#### Parameter

By default, the ViewHelper will generate `:sortabl` as parameter. If you need to change name of the parameter, you can do so by simply:

```ruby
# In view
<%= sortabl_th 'Author', :author, id: 'author-column', class: 'author-column', sort_param: :my_custom_sort_param %>

# In controller
@posts = Post.sortabl(sort_by: params[:my_custom_sort_param], only: [:title, :author])
```

Which hyperlink will be rendered, depends on permitted values.
For now, this gem uses [font-awesome-rails](https://github.com/bokmann/font-awesome-rails) for placing icons. So you may want to install font-awesome gem to your project as well. More icon libaries will be supported in future.
Gem works also fine with pagination like [will_paginate](https://github.com/mislav/will_paginate).

Happy sorting ;)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

