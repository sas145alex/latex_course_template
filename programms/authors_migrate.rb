create_table :authors do |t|
  t.string :fn, null: false
  t.string :ln, null: false
  t.string :sn
  t.string :author_index, null: false
  t.timestamps null: false
end
