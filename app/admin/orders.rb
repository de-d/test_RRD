ActiveAdmin.register Order do
  permit_params :first_name, :last_name, :middle_name, :phone, :email,
    :weight, :length, :width, :height, :from, :to, :distance, :price

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :from
    column :to
    column :weight
    column("Объём (см³)") { |order| order.length * order.width * order.height }
    column :distance
    column :price
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :middle_name
      row :phone
      row :email
      row :weight
      row :length
      row :width
      row :height
      row :from
      row :to
      row :distance
      row :price
      row :created_at
    end
  end
end
