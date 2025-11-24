
Clerk.configure do |c|
  c.secret_key = ENV['CLERK_API_SECRET'] || 'sk_'
  c.publishable_key = ENV['CLERK_PUBLISHABLE_KEY'] || 'pk_'
  c.logger = Logger.new(STDOUT)
end
