namespace :migrations do

  desc "Reminding customers of appointments"
  task :reset_service_sequence => :environment do
    services = Service.order("id ASC")
    
    services_grp = services.group_by(&:branch_id)
    puts services_grp.keys.inspect
    puts "------"
        
    services_grp.keys.each do |key|
      puts services_grp[key].inspect
      
      services_grp[key].each_with_index do |service, indx|
        service.update_attribute(:sequence_no, (indx+1))
      end
    end
  end
  
  desc "Migrate branch_id and staff_id to use the resource - OperatingDays Table"
  task :update_operating_days_data => :environment do
    puts "Migrating OperatingDays data..."
    OperatingDay.all.each do |od|
      unless od.branch_id.nil?
        od.update_attribute(:resource_id, od.branch_id)
        od.update_attribute(:resource_type, "Branch")
      end

      unless od.staff_id.nil?
        od.update_attribute(:resource_id, od.staff_id)
        od.update_attribute(:resource_type, "Staff")
      end

    end
  end

end