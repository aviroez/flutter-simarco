import 'customer.dart';
import 'customer_lead.dart';

class CustomerLeadJoin{
  int customer_id;
  int customer_lead_id;
  String name;
  Customer customer;
  CustomerLead customer_lead;

  CustomerLeadJoin(this.customer_id, this.customer_lead_id, this.name, this.customer, this.customer_lead);

}