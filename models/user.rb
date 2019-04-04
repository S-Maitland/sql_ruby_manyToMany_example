require_relative("../db/sql_runner")
require_relative('location.rb')

class User

  attr_reader :id
  attr_accessor :name

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql = "INSERT INTO users
    (
      name
    )
    VALUES
    (
      $1
    )
    RETURNING id"
    values = [@name]
    user = SqlRunner.run( sql, values ).first
    @id = user['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM users"
    values = []
    users = SqlRunner.run(sql, values)
    result = users.map { |user| User.new( user ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM users"
    values = []
    SqlRunner.run(sql, values)
  end

  def locations()
    sql = 'SELECT locations.* FROM locations INNER JOIN visits ON locations.id = visits.location_id WHERE visits.user_id = $1
    '
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map {|location| Location.new(location)}
  end
end
