# frozen_string_literal: true

name 'nginx_simplecgi'

run_list 'test::default'

cookbook 'nginx_simplecgi', path: '.'
cookbook 'test', path: './test/cookbooks/test'

cookbook 'nginx', git: 'https://github.com/sous-chefs/nginx.git', branch: 'main'
cookbook 'perl', git: 'https://github.com/sous-chefs/perl.git', branch: 'main'
cookbook 'yum-epel', git: 'https://github.com/sous-chefs/yum-epel.git', branch: 'main'

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')
  named_run_list recipe_name.to_sym, "test::#{recipe_name}"
end
