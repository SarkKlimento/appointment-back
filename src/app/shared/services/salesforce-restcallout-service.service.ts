import {Injectable} from '@angular/core';
import {Observable} from "rxjs";
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {ActivatedRoute} from '@angular/router';

@Injectable()
export class SalesforceRESTcalloutServiceService {

  readonly consumerKey: string;
  readonly baseEndpoint: string;
  readonly redirect_uri: string;

  private scopeParameters: Array<string> = ['full'];

  constructor(private http: HttpClient, private route: ActivatedRoute) {
    this.consumerKey = "3MVG91BJr_0ZDQ4ts4wXWZjdsb6SUrhvlOJodd2MCjLiglKDaqpQrnEfOgMb8iluoTu8h8FknH7DB1ME1Hp7g";
    this.baseEndpoint = 'https://sark-klimento-dev-ed.my.salesforce.com/services/apexrest/';
    this.redirect_uri = 'https://sark-appointment-app.herokuapp.com/';
  }

  sendRequestToSalesforce(endPoint: string, requestBody: any, token: string): Observable<Object> {
    const httpOptions = {
      headers: new HttpHeaders({
        'Authorization': 'Bearer ' + token,
        'Accept': 'application/json'
      })
    };

    return this.http.post<Object>(this.baseEndpoint + endPoint, requestBody, httpOptions).pipe();
  }

  authorize() {
    (new Promise((resolve, reject) => {
      let loginWindowURL = 'https://login.salesforce.com/services/oauth2/authorize?client_id='
        + this.consumerKey +
        '&redirect_uri=' + this.redirect_uri
        + '&response_type=token&scope=' + this.scopeParameters.join('%20');
      window.open(loginWindowURL, '_self');

      resolve();
    })).then(() => console.log(window.URL));
  }

  getToken(): string {
    const urlString = window.location.href;
    const startIndex =urlString.indexOf('#') + 14;
    const endIndex = urlString.indexOf('&', startIndex);

    return startIndex > -1 && endIndex > -1 ? urlString.substring(startIndex, endIndex) : null;
  }
}
