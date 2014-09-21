class RecalculateTotals
  def self.perform
    ActiveRecord::Base.logger = nil
    Item.all.find_each do |item|
      # Scan explicit mods
      item.explicit_mods.each do |item_mod|
        primary_value = item_mod.primary_value
        secondary_value = item_mod.secondary_value
        # Check if matching implicit mod
        implicit_mod = Mod.where(name: item_mod.mod.name, explicit: false, total: false).first
        item_implicit_mod = ItemMod.where(mod_id: implicit_mod.id, item_id: item.id).first if implicit_mod
        if item_implicit_mod
          primary_value += item_implicit_mod.primary_value
          secondary_value += item_implicit_mod.secondary_value
        end
        # Check if matching total mod
        total_mod = Mod.where(name: item_mod.mod.name, total: true).first
        item_total_mod = ItemMod.where(mod_id: total_mod.id, item_id: item.id).first if total_mod
        if item_total_mod
          item_total_mod.primary_value = primary_value
          item_total_mod.secondary_value = secondary_value
          item_total_mod.total_value = item_total_mod.primary_value + item_total_mod.secondary_value
          if item_total_mod.changed?
            item_total_mod.save 
            puts "Updated #{item_total_mod.mod.name} for #{item.id} #{item.name}"
          end
        end
      end
    end
  end
end