/*
 * @Date: 2023-11-30 10:36:26
 * @Description:
 */
declare module "react-native-douyin-sdk" {
  export function init(appKey: string): void;
  export function auth(scope: string, state: string): Promise<any>;
  export function share(path: string, isPublish: string): Promise<any>;
  export function shareVideo(path: string, isPublish: string): Promise<any>;
  export function shareLink(options: any): Promise<any>;
}
