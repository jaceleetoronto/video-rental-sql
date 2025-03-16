import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class DatabaseGUI extends JFrame {
    private static final String DB_URL = "jdbc:oracle:thin:@oracle.cs.torontomu.ca:1521:orcl";
    private static final String DB_USERNAME = "p83lee";
    private static final String DB_PASSWORD = "01134772";

    private JTextArea outputArea;
    private JTextField queryField;

    public DatabaseGUI() {
        setTitle("Database Management GUI");
        setSize(700, 500);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        // Output area
        outputArea = new JTextArea();
        outputArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(outputArea);
        add(scrollPane, BorderLayout.CENTER);

        // Buttons Panel
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new GridLayout(1, 4));

        JButton createButton = new JButton("Create Tables");
        JButton populateButton = new JButton("Populate Tables");
        JButton dropButton = new JButton("Drop Tables");
        JButton queryButton = new JButton("Run Query");

        buttonPanel.add(createButton);
        buttonPanel.add(populateButton);
        buttonPanel.add(dropButton);
        buttonPanel.add(queryButton);
        add(buttonPanel, BorderLayout.NORTH);

        // Query Field Panel
        JPanel queryPanel = new JPanel();
        queryPanel.setLayout(new BorderLayout());

        queryField = new JTextField();
        JButton executeQueryButton = new JButton("Execute");
        queryPanel.add(new JLabel("SQL Query:"), BorderLayout.WEST);
        queryPanel.add(queryField, BorderLayout.CENTER);
        queryPanel.add(executeQueryButton, BorderLayout.EAST);
        add(queryPanel, BorderLayout.SOUTH);

        // Add Action Listeners
        createButton.addActionListener(e -> createTables());
        populateButton.addActionListener(e -> populateTables());
        dropButton.addActionListener(e -> dropTables());
        queryButton.addActionListener(e -> runQuery(queryField.getText()));
        executeQueryButton.addActionListener(e -> runQuery(queryField.getText()));

        setVisible(true);
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }

    private void createTables() {
        String createCustomerTable = "CREATE TABLE customer (" +
                "customer_id NUMBER PRIMARY KEY, " +
                "name VARCHAR2(100), " +
                "email VARCHAR2(100))";

        String createEquipmentTable = "CREATE TABLE equipment (" +
                "equipment_id NUMBER PRIMARY KEY, " +
                "name VARCHAR2(100), " +
                "type VARCHAR2(50), " +
                "availability CHAR(1) DEFAULT 'N' CHECK (availability IN ('Y', 'N')), " +
                "price NUMBER)";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(createCustomerTable);
            stmt.executeUpdate(createEquipmentTable);
            outputArea.setText("Tables created successfully.");
        } catch (SQLException e) {
            outputArea.setText("Error creating tables: " + e.getMessage());
        }
    }

    private void populateTables() {
        String insertCustomer = "INSERT INTO customer (customer_id, name, email) VALUES (1, 'Alice Johnson', 'alice@example.com')";
        String insertEquipment = "INSERT INTO equipment (equipment_id, name, type, availability, price) VALUES (1, 'Camera', 'Electronics', 'Y', 500)";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(insertCustomer);
            stmt.executeUpdate(insertEquipment);
            outputArea.setText("Tables populated with dummy data.");
        } catch (SQLException e) {
            outputArea.setText("Error populating tables: " + e.getMessage());
        }
    }

    private void dropTables() {
        String dropCustomerTable = "DROP TABLE customer";
        String dropEquipmentTable = "DROP TABLE equipment";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(dropCustomerTable);
            stmt.executeUpdate(dropEquipmentTable);
            outputArea.setText("Tables dropped successfully.");
        } catch (SQLException e) {
            outputArea.setText("Error dropping tables: " + e.getMessage());
        }
    }

    private void runQuery(String query) {
        if (query == null || query.isEmpty()) {
            outputArea.setText("Please enter a valid query.");
            return;
        }

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();

            // Print column headers
            StringBuilder result = new StringBuilder();
            for (int i = 1; i <= columnCount; i++) {
                result.append(meta.getColumnName(i)).append("\t");
            }
            result.append("\n");

            // Print rows
            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    result.append(rs.getString(i)).append("\t");
                }
                result.append("\n");
            }
            outputArea.setText(result.toString());
        } catch (SQLException e) {
            outputArea.setText("Error executing query: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(DatabaseGUI::new);
    }
}

