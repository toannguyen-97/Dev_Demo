//
//  NetworkConstants.swift
//  GMA
//
//  Created by Hoàn Nguyễn on 1/12/22.
//

import Foundation

// Staging EVN
struct NetworkConstants {
    static let isProduction = false
    static let isDisableProtections = true  // set true to disable SSLPining and Root detection
    static let isDisableCache = true
    
    static let OpenWeatherMapURL = "https://api.openweathermap.org/data/2.5/weather"
    static let oktaBaseURL = "https://aspire.oktapreview.com/"
    
    static let countryListBaseURL = "https://app-configuration-staging.azurewebsites.net/api/Get?code=/jnlaDWexK51GLUn4n6QJOC9K8V7eGCPwzyfAEMQ2RqBOn13Jud0Xw==&applicationId=Gma-Config&clientId=*"
    static let airportListBaseURL = "https://api.aspirelifestyles.com/app-configuration-staging/Get?code=SEE4vG%7Cph/DvtamVsrwYTXa91pYAYyHXQ74YT/EiyhCyLARHZIbMEg==&ApplicationId=AirportCode_Location&ClientId=*"
    static let jwtGeneratorBaseURL = "https://jwt-token-generator-dev.azurewebsites.net/CreateASymmetricToken/"
    static let kenticoBaseURL = "https://deliver.kontent.ai/"
    static let flightInfoBaseURL = "https://xml.flightview.com/FlightStatusJsonDemo/fvxml.exe"
    
    // AZure API
    static let azureBaseURL = "https://api.aspirelifestyles.com/"
    static let azureProgramInfoURL = "https://api.aspirelifestyles.com/concierge-info-staging/programInfo/"
    static let azurecreateCustomerURL = "https://api.aspirelifestyles.com/customers-staging/registration/"
    static let azureGenerateEmailOTPURL = "https://api.aspirelifestyles.com/customers-staging/generateotp/"
    static let azureValidateOTPURL = "https://api.aspirelifestyles.com/customers-staging/validateotp/"
    static let azureUserProfileURL = "https://api.aspirelifestyles.com/users-staging/profile/"
    static let azureRequestHistoryURL = "https://api.aspirelifestyles.com/request-history-staging/requestHistory/"
    static let azureCaseURL = "https://api.aspirelifestyles.com/aspire-epc-exp-staging/cases/"
    static let azureContentURL = "https://api.aspirelifestyles.com/content-api-staging/"
    static let azureContentPrioritizationURL = "https://api.aspirelifestyles.com/content-prioritization-staging/"
    static let azureSearchPartyURL = "https://api.aspirelifestyles.com/users-staging/searchParty"
    // Limo
    static let azureLimoQuoteURL = "https://api.aspirelifestyles.com/limo-staging/quote"
    static let azureLimoMakebookingURL = "https://api.aspirelifestyles.com/limo-staging/Makebooking"
    static let azureLimoGetBookingURL = "https://api.aspirelifestyles.com/limo-staging/booking"
    // Dining
    static let azureDiningContentURL = "https://api.aspirelifestyles.com/aspire-dining-staging/"
    static let azureDiningReservationURL = "https://api.aspirelifestyles.com/dining-staging/v1/reservation/"
    static let domainsToVerifyCertificate: [String] = ["api.aspirelifestyles.com", "aspire.oktapreview.com"]
    //adyen
    static let checkoutAdyen = "https://checkout-test.adyen.com/v71/"
    static let domainsToSkipCertificateVerification: [String] = []
    
    // Okta
    static let oktaClientId = Obfuscated._0.o.a.e.a.n.v.k.z.e.v.w.M.j.X.A.Y._0.h._7
    static let oktaClientSecret = Obfuscated._4.e.N.O.L.g.h.F.G.D.C.D.H.B.m._2.S.d.c.E._4._8.w.c.w.G.f.P.t.K.Y.m.o.L.X._8.p.I._7.F
    static let oktaTokenType = Obfuscated.S.S.W.S
    static let oktaTokenSecret = Obfuscated._0._0.Q.l.C.f.z.o.S.p.t.e._2.u.e.K.d.underscore.v.underscore.x.N.y.H.D.C.A.Z.k.Z.X.R.e.s.Y.V.underscore._8.V.Z._8.M
    // Aspire
    static let aspireServiceAccount = Obfuscated.d.m.a.dash.s.t.g.dot.s.e.r.v.i.c.e.at.a.s.p.i.r.e.dot.c.o.m
    static let aspireServiceSecret = Obfuscated.P.at._5._5.w._0.r.d._2._3._4.exclamation.ampersand.s.t.g
    // PMA
    static let pmaAuthAccID = Obfuscated._0.o.a._1.p._9.x.v.d.r.s.L.w.U._0.M.S._0.i._7
    static let pmaAuthPas = Obfuscated.w.v.z.r.h._2.e.W.n.n.H.l.A._2._8.f.P.u.w.C._3.o._9.z.K.b.h.s.T.m._0.d.s.V.p.Y.p.b.x.b
    static let pmaServicesAccount = Obfuscated.s.v.c.underscore.P.M.A.underscore.O.K.T.A.at.i.s.o.s.d.e.v.dot.c.o.m
    static let pmaServicesSecret = Obfuscated.P.at.s.s.w.o.r.d._1._2._3
    
    //Key
    static let contentSubscriptionKey = Obfuscated._1._1._3.f._1.c._2.e._3.f.f._4._4.e._2._9.b.a._8._2.c._5._0.a._8.a._5._6._4._3.b.a
    static let subscriptionKey =  Obfuscated.e.d.b._2.f._5._3._0._3._9.d._5._4._1._0.e._9.f.f._3.a._9.c._1.a.d.b._4.c.b.d.f
    static let defaultOrganization = "DMA"
    static let defaultProgramName = "DEMO SINGAPORE"
    static let adyenPublicKey = "10001|C6FCAF16ACA3A787BE14A4564532FA1C5A60E23F1260242836C7F9070D06B9211AEB3E5967B26E3452EA0DE37168EF6387248FD9CD9B8383B7B1D77C2100F06FEC3BE6DAD9E8074D244298243BFD2F4CB7ABDEFEE60C9399110D2DE3F0CE2F2D8916BEA06ADCD9342C22AB2E35B7334C80EDB259CEA7BDD730CB7C272DF73C37B69B3837F61A577930902803F3036C93526D0498C553586A963CD77E86369EB5292E149A34FF8A371A1548FCFD90E90026546488C886224D19BAD6AF3BEA1AE604D8DB647A35B7F66AB324785DED72FB76C8CC2FE48C70D60F8A86F2E8A5551CE67D634E990D5405E3100F83805ED74CD84B1A83154FA2D0D88E94AAADA65811"
    static let adyenClientKey = "test_C6AKLADZTZEU3KOAEURTBFGMKQUILSU4"
    static let adyenAPIKey = "AQEuhmfuXNWTK0Qc+iSRgXQxteG3QY1IHodTVGBF73aoH2pMsVQarkXQeDfxmx55SxDBXVsNvuR83LVYjEgiTGAH-LPVmgDSjEPFpfhfetBFejpN9uLo/iXpjg5OhIcQRxMQ=-39ZLb]fd5W&f87If"
    static let adyenMerchantAccount = "AspireLifestylesIncCOM"
    static let xAppId =  Obfuscated.e.d.b._2.f._5._3._0._3._9.d._5._4._1._0.e._9.f.f._3.a._9.c._1.a.d.b._4.c.b.d.f
    static let diningSubscriptionKey = Obfuscated._8.f._9._9._4.b._3._7._7._9.c.e._4.a._4._1.a._0._0._2._6._1.a._4._4._3.e.e.c._9.e._5

    //Kentico
    static let kenticoProjectID =  Obfuscated.a._2.e.c.e._3._6._9.dash.e.a.d._6.dash._0._0.d._2.dash.f.f.a._3.dash._2.b._9.f.c.a._3._3._4._4.e._0
}
