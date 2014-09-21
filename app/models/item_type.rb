class ItemType < ActiveRecord::Base
  
  has_many :base_types
  
  def self.for_select
    output = []
    families = self.select('DISTINCT(item_types.family), item_types.order').order('item_types.order')
    families.each do |family|
      types = ItemType.where(family: family.family).map { |t| [t.name, t.id] }
      if family.family == 'Weapons'
        axe_1h = ItemType.where(name: 'One Hand Axe').first.id
        sword_1h = ItemType.where(name: 'One Hand Sword').first.id
        mace_1h = ItemType.where(name: 'One Hand Mace').first.id
        axe_2h = ItemType.where(name: 'Two Hand Axe').first.id
        claw = ItemType.where(name: 'Claw').first.id
        sceptre = ItemType.where(name: 'Sceptre').first.id
        dagger = ItemType.where(name: 'Dagger').first.id
        wand = ItemType.where(name: 'Wand').first.id
        sword_2h = ItemType.where(name: 'Two Hand Sword').first.id
        mace_2h = ItemType.where(name: 'Two Hand Mace').first.id
        staff = ItemType.where(name: 'Staff').first.id
        bow = ItemType.where(name: 'Bow').first.id
        types.unshift ['Any One Hand Weapon', "#{axe_1h},#{sword_1h},#{mace_1h},#{claw},#{sceptre},#{dagger},#{wand}"]
        types.unshift ['Any Two Hand Weapon', "#{axe_2h},#{sword_2h},#{mace_2h},#{bow},#{staff}"]
      end
      output << [family.family, types]
    end
    output
  end
end
