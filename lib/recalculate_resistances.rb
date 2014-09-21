class RecalculateResistances
  include Resque::Plugins::UniqueJob

  @queue = :administration_queue

  def self.perform
    Item.all.find_each do |item|
      next if item.total_resistance > 0
      item.resistance_mods.each do |mod|
          case mod.mod.name
          when "+#% to Chaos Resistance"
            item.chaos_resistance += mod.total_value
            item.total_resistance += mod.total_value
            item.num_resistances += 1
          when "+#% to Fire and Cold Resistances"
            item.fire_resistance += mod.total_value
            item.cold_resistance += mod.total_value
            item.total_ele_resistance += mod.total_value*2
            item.total_resistance += mod.total_value*2
            item.num_ele_resistances += 2
            item.num_resistances += 2
          when "+#% to Fire and Lightning Resistances"
            item.fire_resistance += mod.total_value
            item.lightning_resistance += mod.total_value
            item.total_ele_resistance += mod.total_value*2
            item.total_resistance += mod.total_value*2
            item.num_ele_resistances += 2
            item.num_resistances += 2
          when "+#% to Cold and Lightning Resistances"
            item.cold_resistance += mod.total_value
            item.lightning_resistance += mod.total_value
            item.total_ele_resistance += mod.total_value*2
            item.total_resistance += mod.total_value*2
            item.num_ele_resistances += 2
            item.num_resistances += 2
          when "+#% to Fire Resistance"
            item.fire_resistance += mod.total_value
            item.total_ele_resistance += mod.total_value
            item.total_resistance += mod.total_value
            item.num_ele_resistances += 1
            item.num_resistances += 1
          when "+#% to all Elemental Resistances"
            item.fire_resistance += mod.total_value
            item.cold_resistance += mod.total_value
            item.lightning_resistance += mod.total_value
            item.total_ele_resistance += mod.total_value*3
            item.total_resistance += mod.total_value*3
            item.num_ele_resistances += 1
            item.num_resistances += 1
          when "+#% to Lightning Resistance"
            item.lightning_resistance += mod.total_value
            item.total_ele_resistance += mod.total_value
            item.total_resistance += mod.total_value
            item.num_ele_resistances += 1
            item.num_resistances += 1
          when "+#% to Cold Resistance"
            item.cold_resistance += mod.total_value
            item.total_ele_resistance += mod.total_value
            item.total_resistance += mod.total_value
            item.num_ele_resistances += 1
            item.num_resistances += 1
          end
      end
      item.save if item.changed?
    end
  end
end