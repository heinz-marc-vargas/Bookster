Factory.define(:company) do |company|
  company.name "New Company"
  company.subdomain "new-company"
end

Factory.define(:country) do |country|
  country.name "Singapore"
  country.locale "en"
  country.language "English"
end

Factory.define(:branch) do |branch|
  branch.name 'Branch Name'
  branch.company_id 1
  branch.country_id 1
  branch.address_1 "Weeeeh Street"
  branch.address_2 "Crap Avenue"
  branch.zipcode 120379
  branch.subdomain "branchname"
end

Factory.define(:service) do |service|
  service.name "QA Testing"
  service.company_id 1
  service.duration 180
  service.charge 500
  service.description "Throughly test your software."
end