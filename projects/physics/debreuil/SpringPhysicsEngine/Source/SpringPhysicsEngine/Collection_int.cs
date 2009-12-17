//using System;
//using System.Drawing;

//namespace Sky
//{
//    class Collection_PointF
//    {
//        public PointF[] Collection = new PointF[0];

//        public void Add(PointF add)
//        {
//            PointF[] temp = Collection;

//            Collection = new PointF[Collection.Length + 1];

//            for (int i = 0; i < temp.Length; i++)
//            {
//                Collection[i] = temp[i];
//            }

//            Collection[Collection.Length - 1] = add;
//        }

//        public void Clear()
//        {
//            Collection = new PointF[0];
//        }

//        public void Remove(PointF remove)
//        {
//            int index = -1;

//            for (int i = 0; i < Collection.Length; i++)
//            {
//                if (Collection[i] == remove)
//                {
//                    index = i;
//                    break;
//                }
//            }

//            PointF[] temp = new PointF[Collection.Length - 1];

//            for (int i = 0; i < index; i++)
//            {
//                temp[i] = Collection[i];
//            }

//            for (int i = 0; i < Collection.Length - index - 1; i++)
//            {
//                temp[index + i] = Collection[index + i + 1];
//            }
//        }
//    }
//}
