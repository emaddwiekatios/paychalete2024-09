import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
admin.initializeApp()
const fcm = admin.messaging()
const db = admin.firestore()


export const sendToDeviceCreate = functions.firestore
.document('Payments/{Id}')
    .onCreate(async (snapshot) => {
        const Payment = snapshot.data()
        const tokens = []
        const token = await db
            .collection('PaymentsToken').get();
        for (let i = 0; i < token.docs.length; i++) {

console.log("inside for ");
       console.log(token.docs[i].data()['token'].toString());
            tokens.push(token.docs[i].data()['token'].toString());
        }
console.log("tokens");
console.log(tokens);
        const payload = {
            notification: {
                title: `Payment  Created =:   Payment id = ${Payment.Payment_id} `,
                body: `Payment name:  ${Payment.Payment_name} Payment date=${Payment.Payment_entry_date}`,
               click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        }
        return fcm.sendToDevice(tokens, payload)
    })




exports.sendPaymentsToDeviceDelete= functions.firestore
    .document('Payments/{Id}')
    .onDelete(async (snapshot) => {
   const Payment = snapshot.data()
        const tokens = []
        const token = await db
        .collection('PaymentsToken').get();
    for (let i = 0; i < token.docs.length; i++) {

console.log("inside for ");
       console.log(token.docs[i].data()['token'].toString());
        tokens.push(token.docs[i].data()['token'].toString());
    }
console.log("tokens");
console.log(tokens);
    const payload = {
        notification: {
              title: `Payment  Deleted =:   Payment id = ${Payment.Payment_id} `,
            body: `Payment name:  ${Payment.Payment_name} Payment date=${Payment.Payment_entry_date}`,

        click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
    }
    return fcm.sendToDevice(tokens, payload)
})



exports.sendPaymentsToDeviceUpdate= functions.firestore
    .document('Payments/{Id}')
    .onUpdate(async(change) =>  {
       const Payment = change.before.data()
        const Paymentafter = change.after.data()

    //get token yyy
        const tokens = [];
        const token = await db
        .collection('PaymentsToken').get()
    for (let i = 0; i < token.docs.length; i++) {
console.log("inside for ");
       console.log(token.docs[i].data()['token'].toString())
        tokens.push(token.docs[i].data()['token'].toString())
    }
const tokennew = await db.collection('PaymentsToken').get()
     for (let i = 0; i < tokennew.docs.length; i++) {
console.log("inside for ");
       console.log(tokennew.docs[i].data()['token'].toString())

    }


console.log("tokens");
console.log(tokens);
tokens.push('fJoYgA-sLEsXm0Tjfy8gUl:APA91bHNHBmHWSpE4ZgVfiWd4RVTvxMVT0klUmCc7ELG26JStRDnDjNY1I9uV2cRAMFm-FO5WRb34d6rvaozyl1md5k7WjHgVmxu2-QMfn4ultHAxG2weYQtjbo9Ibs4EB_1ZMoJnbGD');
   const payload = {
        notification: {
            title: `Payment  Updated =:   Payment id = ${Payment.Payment_id} `,
            body: `Payment name old :  ${Payment.Payment_name} Payment name after=${Paymentafter.Payment_name}`,

 click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      }
    return fcm.sendToDevice(tokens, payload)
})
