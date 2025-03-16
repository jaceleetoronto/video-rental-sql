import java.sql.Connection;
import java.sql.DriverManager;

public class TestConnection {
    public static void main(String[] args) {
        String dbUrl = "jdbc:oracle:thin:@oracle.cs.torontomu.ca:1521:orcl";
        String username = "p83lee";
        String password = "01134772";

        try (Connection conn = DriverManager.getConnection(dbUrl, username, password)) {
            System.out.println("Connected to the database successfully!");
        } catch (Exception e) {
            System.out.println("Error connecting to the database: " + e.getMessage());
        }
    }
}

