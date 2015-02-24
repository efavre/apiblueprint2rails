class Create<%= plural_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%= plural_name %> do |t|
      t.timestamps
      # ...
    end
  end
end
