//
//  NetworkConstants.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/12/22.
//

import Foundation

// Production EVN
struct NetworkConstants {
    static let isProduction = true
    static let isDisableProtections = false
    static let isDisableCache = true
    
    
    static let OpenWeatherMapURL = "https://api.openweathermap.org/data/2.5/weather"
    static let oktaBaseURL = "https://aspire.okta-emea.com/"
    static let countryListBaseURL = "https://app-configuration-prod.azurewebsites.net/api/Get?code=FW%2feg1gyauJ0ZtbDcdReoRlsKa9j8D7Pjuy2MGxCpFbhNZRpZ7QKZQ%3d%3d&ApplicationId=Gma-Config&ClientId=*"
    static let airportListBaseURL = "https://api.aspirelifestyles.com/app-configuration-staging/Get?code=SEE4vG%7Cph/DvtamVsrwYTXa91pYAYyHXQ74YT/EiyhCyLARHZIbMEg==&ApplicationId=AirportCode_Location&ClientId=*"
    static let jwtGeneratorBaseURL = "https://api.aspirelifestyles.com/chats/CreateASymmetricToken"
    static let kenticoBaseURL = "https://deliver.kontent.ai/"
    static let flightInfoBaseURL = "https://xml.flightview.com/FlightStatusJsonDemo/fvxml.exe"
    
    // AZure API
    static let azureBaseURL = "https://api.aspirelifestyles.com/"
    static let azureProgramInfoURL = "https://api.aspirelifestyles.com/clients/programInfo/"
    static let azurecreateCustomerURL = "https://api.aspirelifestyles.com/customers/registration/"
    static let azureGenerateEmailOTPURL = "https://api.aspirelifestyles.com/customers/generateotp/"
    static let azureValidateOTPURL = "https://api.aspirelifestyles.com/customers/validateotp/"
    static let azureUserProfileURL = "https://api.aspirelifestyles.com/users/profile/"
    static let azureRequestHistoryURL = "https://api.aspirelifestyles.com/request-history/requestHistory"
    static let azureCaseURL = "https://api.aspirelifestyles.com/aspire-epc-exp-prod/cases/"
    static let azureContentURL = "https://api.aspirelifestyles.com/content-apis-prod"
    static let azureContentPrioritizationURL = "https://api.aspirelifestyles.com/content-prioritization-prod/"
    static let azureSearchPartyURL = "https://api.aspirelifestyles.com/users/searchParty"
    // Limo
    static let azureLimoQuoteURL = "https://api.aspirelifestyles.com/limo-staging/quote"
    static let azureLimoMakebookingURL = "https://api.aspirelifestyles.com/limo-staging/Makebooking"
    static let azureLimoGetBookingURL = "https://api.aspirelifestyles.com/limo-staging/booking"
    // Dining
    static let azureDiningContentURL = "https://api.aspirelifestyles.com/aspire-dining-prod/"
    static let azureDiningReservationURL = "https://api.aspirelifestyles.com/dining/v1/reservation/"
    
    static let domainsToVerifyCertificate: [String] = ["api.aspirelifestyles.com", "aspire.okta-emea.com"]
    static let domainsToSkipCertificateVerification: [String] = []
    
    // Okta
    static let oktaClientId = Obfuscated._0.o.a._2._3.j.t._1.j.u.V.F.g.S.y._2.k._0.i._7
    static let oktaClientSecret = Obfuscated._8.d._2.U.l.q.y.l.P.u.Y._6.k.z.R.t.E.T.b.l._5.O.p.O.a._6._0.W.l.r.N.underscore.b.h.f.H._5.A.h.U
    static let oktaTokenType = Obfuscated.S.S.W.S
    static let oktaTokenSecret = Obfuscated._0._0.H._0.r.G.z.Z.z.Q.a.b.e.Y._4.W.K.r.S.h.g.O.k.A.g.E.O._6.E._5.t.I._9.P.W._4._9._4.V.V.M.e
    // Aspire
    static let aspireServiceAccount = Obfuscated.d.m.a.dash.p.r.o.d.at.a.s.p.i.r.e.dot.o.r.g
    static let aspireServiceSecret = Obfuscated.P.at.s.s.w._0.r.d._1._2._3._4
    // PMA
    static let pmaAuthAccID = Obfuscated._0.o.a._1.z._7.n._0._5.r.C.V._3.f.e.i.v._0.i._7
    static let pmaAuthPas = Obfuscated.n.F.d.Q.W.k.l.E.g.S.U.t.k.N._5.X.h.X.j.T.o.J.Q.W.D.L.X.I.i.underscore.S.H.M.Y.o.t.A.I.Z._2
    static let pmaServicesAccount = Obfuscated.S.V.C.underscore.P.M.A.underscore.S.M.A.P.P.at.i.n.t.e.r.n.a.t.i.o.n.a.l.s.o.s.dot.c.o.m
    static let pmaServicesSecret = Obfuscated.P.at.s.s.w._0.r.d._2._8
    
    //Key
    static let contentSubscriptionKey = Obfuscated._1._1._3.f._1.c._2.e._3.f.f._4._4.e._2._9.b.a._8._2.c._5._0.a._8.a._5._6._4._3.b.a
    static let subscriptionKey =  Obfuscated._1._1._3.f._1.c._2.e._3.f.f._4._4.e._2._9.b.a._8._2.c._5._0.a._8.a._5._6._4._3.b.a
    static let defaultOrganization = "DMA"
    static let defaultProgramName = "DEMO SINGAPORE"
    static let adyenPublicKey = "10001|C6FCAF16ACA3A787BE14A4564532FA1C5A60E23F1260242836C7F9070D06B9211AEB3E5967B26E3452EA0DE37168EF6387248FD9CD9B8383B7B1D77C2100F06FEC3BE6DAD9E8074D244298243BFD2F4CB7ABDEFEE60C9399110D2DE3F0CE2F2D8916BEA06ADCD9342C22AB2E35B7334C80EDB259CEA7BDD730CB7C272DF73C37B69B3837F61A577930902803F3036C93526D0498C553586A963CD77E86369EB5292E149A34FF8A371A1548FCFD90E90026546488C886224D19BAD6AF3BEA1AE604D8DB647A35B7F66AB324785DED72FB76C8CC2FE48C70D60F8A86F2E8A5551CE67D634E990D5405E3100F83805ED74CD84B1A83154FA2D0D88E94AAADA65811"
    static let adyenClientKey = "test_C6AKLADZTZEU3KOAEURTBFGMKQUILSU4"
    static let adyenAPIKey = "AQEuhmfuXNWTK0Qc+iSRgXQxteG3QY1IHodTVGBF73aoH2pMsVQarkXQeDfxmx55SxDBXVsNvuR83LVYjEgiTGAH-LPVmgDSjEPFpfhfetBFejpN9uLo/iXpjg5OhIcQRxMQ=-39ZLb]fd5W&f87If"
    static let adyenMerchantAccount = "AspireLifestylesIncCOM"
    static let xAppId =  Obfuscated._3._4._9._7._7._7._6._5._5._3._8.e._4._6.f.f.b.f._4._9._8.c.a.f.a._6._8.b._0.c._5._6  //Obfuscated.e.d.b._2.f._5._3._0._3._9.d._5._4._1._0.e._9.f.f._3.a._9.c._1.a.d.b._4.c.b.d.f
    static let diningSubscriptionKey = Obfuscated._1._1._3.f._1.c._2.e._3.f.f._4._4.e._2._9.b.a._8._2.c._5._0.a._8.a._5._6._4._3.b.a
    //Kentico
    static let kenticoProjectID =  Obfuscated.a._2.e.c.e._3._6._9.dash.e.a.d._6.dash._0._0.d._2.dash.f.f.a._3.dash._2.b._9.f.c.a._3._3._4._4.e._0
    
    
}
