import dao.DAO;
import model.people.Customer;
import model.people.Employee;
import model.people.Person;
import service.CustomerService;
import service.PersonService;
import service.Service;

import java.io.IOException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) throws IOException {

        CustomerService customerService = new CustomerService();
        PersonService personService = new PersonService();

        // Choups le iencli
        Customer c = new Customer("Choupault", "Alexis", "alexis.choupault@gmail.com", new GregorianCalendar(1998,8,18));

        // Choups est en bdd
        customerService.create(c);

        //On voit que "id" est rempli
        System.out.println("ID: "+c.getId());

        //Utilisation de java 8, le premier que je vois faire des for(...){} je lui casse les dents
        //On affiche la classe des objets <Person> trouvés en bdd, ici cela devrait afficher "Customer" pour choups
        personService.findAll()
                .stream()
                .map(Person::toString)
                .forEach(System.out::println);

        // Ici l'objet renvoyé est Person car un employé et un client ont tout les deux une email
        Person employeeOrCustomer = personService.findByEmail("alexis.choupault@gmail.com");
        //On détermine donc si c'est un employé ou un client et on cast après....
        if(employeeOrCustomer instanceof Customer) System.out.println("Choups est Customer");
        if(employeeOrCustomer instanceof Employee) System.out.println("Choups est Employee");

        //Truncate table
        if(personService.deleteAllEntitiesFromTable() > 0 && personService.findAll().isEmpty()) {
            System.out.println("Tous les objets ont été supprimés");
        }
    }
}
