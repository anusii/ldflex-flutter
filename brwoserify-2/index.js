import { PathFactory } from 'ldflex';
import LDflexComunicaEngine from '@ldflex/comunica';
import dataModel from '@rdfjs/data-model';
import { subjectHandlers } from './packages/query-solid/src/RootPath';
import { Session } from '@rubensworks/solid-client-authn-isomorphic';

const SESSION_KEY = '@comunica/actor-http-inrupt-solid-client-authn:session'

function createSession(options) {
  const session = new Session({});
  session.login(options.session);
  return session;
}

function pathFactory(sources, options) {
  if (!SESSION_KEY in options && session in options) {
    const session = new Session({});
    session.login(options.session);
  }
  const queryEngine = options?.queryEngine ?? new LDflexComunicaEngine(sources, options);
  const context = options?.context ?? {};
  return new PathFactory({ queryEngine, context, [SESSION_KEY]: options[SESSION_KEY] ?? createSession(options) });
}

const NAMESPACE = /^[^]*[#/]/;

function createPathUsingFactory(factory) {
  return function createPath(node, sources, options) {
    const _options = options ?? {}
    const subject = typeof node === 'string' ? dataModel.namedNode(node) : node;
    
    const namespace = NAMESPACE.exec(subject.value)?.[0] ?? ''
    
    // Try and use the original nodes namespace for the vocab if no context is provided
    const context = _options.context ?? { '@context': { '@vocab': namespace } }

    // Use the query solid handlers to get activityStream support
    const handlers = _options.handlers ?? subjectHandlers
  
    return factory(sources ?? namespace, { ..._options, context, handlers }).create({ subject });
  }
}

export const createPath = createPathUsingFactory(pathFactory);
// export const createPath = createPath;

// global.myFunc = createPathUsingFactory(pathFactory);
