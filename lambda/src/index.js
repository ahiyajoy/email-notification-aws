import { getTableItems } from "./helpers/dynamodb";
import { sendEmail } from "./helpers/ses";

export const handler = async (event) => {
  console.log(event.name);
  // get table items
  const data = await getTableItems();
  // Check if subscription expiry is in 1 week.
  const customersToNotify = getCustomersToNotify(data);
  console.log(customersToNotify);

  for await (const element of customersToNotify) {
    const message = `Dear ${element.userName},\n
    Your subscription ends in ${element.daysToExpire} days, Please renew your subscription
    to continue enjoying our service.\n
    Regards
    *** Team!`;
    await sendEmail(element.emailId, message);
  }
};

// return object [ {emailId, userName, daysToExpire} ]
function getCustomersToNotify(customerData) {
  const customerExpiryData = [];
  customerData.forEach((customer) => {
    const subscriptionEndDate = Date.parse(customer.subscriptionEnd);
    const daysToExpire =
      (subscriptionEndDate - Date.now()) / (1000 * 3600 * 24);
    if (daysToExpire < 7)
      customerExpiryData.push({
        emailId: customer.EmailId,
        userName: customer.userName,
        daysToExpire: Math.floor(daysToExpire),
      });
  });
  return customerExpiryData;
}

handler({});
