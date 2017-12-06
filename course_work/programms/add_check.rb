def change
  reversible do |dir|
    dir.up do
      execute "ALTER TABLE authors ADD CONSTRAINT chk_author_ind_length
        CHECK (length(author_index) >= 3)"
    end
  end
end
