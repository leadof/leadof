import { isPlatformBrowser } from '@angular/common';
import {
  ApplicationConfig,
  importProvidersFrom,
  isDevMode,
  PLATFORM_ID,
} from '@angular/core';
import { RouteReuseStrategy, provideRouter } from '@angular/router';
import { provideServiceWorker } from '@angular/service-worker';

import { IonicModule, IonicRouteStrategy } from '@ionic/angular';

import { routes } from './app.routes';

export const config: ApplicationConfig = {
  providers: [
    // { provide: RouteReuseStrategy, useClass: IonicRouteStrategy },
    importProvidersFrom(IonicModule.forRoot({})),
    provideRouter(routes),
    // provideServiceWorker('ngsw-worker.js', {
    //   enabled: !isDevMode() && isPlatformBrowser(PLATFORM_ID),
    //   registrationStrategy: 'registerWhenStable:30000',
    // }),
  ],
};
