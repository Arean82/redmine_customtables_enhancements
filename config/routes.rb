resources :custom_table_enhancements, only: [:index, :edit, :update]

get 'custom_table_enhancements/:table_id/settings', to: 'custom_table_enhancements#settings', as: 'custom_table_enhancement_settings'

