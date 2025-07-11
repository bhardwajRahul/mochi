// outer_join.mochi
import java.util.*;

class IdName {
    int id;
    String name;
    IdName(int id, String name) {
        this.id = id;
        this.name = name;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof IdName other)) return false;
        return Objects.equals(this.id, other.id) && Objects.equals(this.name, other.name);
    }
    @Override public int hashCode() {
        return Objects.hash(id, name);
    }
    int size() { return 2; }
}
class IdCustomerIdTotal {
    int id;
    int customerId;
    int total;
    IdCustomerIdTotal(int id, int customerId, int total) {
        this.id = id;
        this.customerId = customerId;
        this.total = total;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof IdCustomerIdTotal other)) return false;
        return Objects.equals(this.id, other.id) && Objects.equals(this.customerId, other.customerId) && Objects.equals(this.total, other.total);
    }
    @Override public int hashCode() {
        return Objects.hash(id, customerId, total);
    }
    int size() { return 3; }
}
class OrderCustomer {
    IdCustomerIdTotal order;
    IdName customer;
    OrderCustomer(IdCustomerIdTotal order, IdName customer) {
        this.order = order;
        this.customer = customer;
    }
    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OrderCustomer other)) return false;
        return Objects.equals(this.order, other.order) && Objects.equals(this.customer, other.customer);
    }
    @Override public int hashCode() {
        return Objects.hash(order, customer);
    }
    int size() { return 2; }
}
public class OuterJoin {
    public static void main(String[] args) {
    List<IdName> customers = new ArrayList<>(Arrays.asList(new IdName(1, "Alice"), new IdName(2, "Bob"), new IdName(3, "Charlie"), new IdName(4, "Diana")));
    List<IdCustomerIdTotal> orders = new ArrayList<>(Arrays.asList(new IdCustomerIdTotal(100, 1, 250), new IdCustomerIdTotal(101, 2, 125), new IdCustomerIdTotal(102, 1, 300), new IdCustomerIdTotal(103, 5, 80)));
    List<OrderCustomer> result = (new java.util.function.Supplier<List<OrderCustomer>>(){public List<OrderCustomer> get(){
    List<OrderCustomer> res0 = new ArrayList<>();
    java.util.Set<Object> _matched = new java.util.HashSet<>();
    for (var o : orders) {
        List<IdName> tmp1 = new ArrayList<>();
        for (var it2 : customers) {
            var c = it2;
            if (!(Objects.equals(o.customerId, c.id))) continue;
            tmp1.add(it2);
            _matched.add(it2);
        }
        if (tmp1.isEmpty()) tmp1.add(null);
        for (var c : tmp1) {
            res0.add(new OrderCustomer(o, c));
        }
    }
    for (var c : customers) {
        if (!_matched.contains(c)) {
            IdCustomerIdTotal o = null;
            res0.add(new OrderCustomer(o, c));
        }
    }
    return res0;
}}).get();
    System.out.println("--- Outer Join using syntax ---");
    for (OrderCustomer row : result) {
        if (row.order != null) {
            if (row.customer != null) {
                System.out.println("Order" + " " + row.order.id + " " + "by" + " " + row.customer.name + " " + "- $" + " " + row.order.total);
            }
            else {
                System.out.println("Order" + " " + row.order.id + " " + "by" + " " + "Unknown" + " " + "- $" + " " + row.order.total);
            }
        }
        else {
            System.out.println("Customer" + " " + row.customer.name + " " + "has no orders");
        }
    }
    }
}
