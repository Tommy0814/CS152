import static java.lang.System.out;

public class Company {
    public static void main(String[] args) {
        Employee dexter = new Employee("Dexter");
        Employee debra = new Employee("Debra");
        out.println("The employees are " + dexter.getName() +
            " and " + debra.getName());
    }
}
